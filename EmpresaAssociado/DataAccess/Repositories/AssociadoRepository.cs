using EmpresaAssociado.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Results;
using System.Drawing;

namespace EmpresaAssociado.DataAccess.Repositories {
    public class AssociadoRepository : IAssociadoRepository {

        private readonly DatabaseManager _dbManager;
        public AssociadoRepository() {
            _dbManager = new DatabaseManager();
        }

        public async Task<Associado> AddAssociadoAsync(AssociadoCadastro associado) {
            Associado associadoRetorno = null;
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "INSERT INTO Associado (Nome, Cpf, DataNascimento) VALUES (@nome, @cpf, @dataNascimento); SELECT SCOPE_IDENTITY()";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@nome", associado.Nome);
                    command.Parameters.AddWithValue("@cpf", associado.Cpf);
                    command.Parameters.AddWithValue("@dataNascimento", associado.DataNascimento);

                    int modified = Convert.ToInt32(await command.ExecuteScalarAsync());
                    if (connection.State == System.Data.ConnectionState.Open)
                        connection.Close();

                    //retorno da associado cadastrado
                    associadoRetorno = new Associado() {
                        Id = modified,
                        Cpf = associado.Cpf,
                        Nome = associado.Nome,
                        DataNascimento = associado.DataNascimento
                    };
                }
            }
            return associadoRetorno;
        }

        public async Task DeleteAssociadoAsync(int idAssociado) {
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "DELETE FROM Associado WHERE Id = @idAssociado";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@idAssociado", idAssociado);

                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task DeleteVinvuloAssociadoEmpresaAsync(int idAssociado) {
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "DELETE FROM EmpresaAssociado WHERE IdAssociado = @idAssociado";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@idAssociado", idAssociado);

                    await command.ExecuteNonQueryAsync();
                }
            }
        }

        public async Task<Associado> GetAssociadoByCpfAsync(string cpf) {
            Associado associado = null;

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT Id, Nome, Cpf, DataNascimento FROM Associado WHERE Cpf = @cpf";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {

                    command.Parameters.AddWithValue("@cpf", cpf);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        if (reader.Read()) {
                            associado = new Associado {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                Cpf = reader["Cpf"].ToString(),
                                DataNascimento = Convert.ToDateTime(reader["DataNascimento"])
                            };
                        }
                    }
                }
            }
            return associado;
        }

        public async Task<Associado> GetAssociadoByIdAsync(int idAssociado) {
            Associado associado = null;

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT Id, Nome, Cpf, DataNascimento FROM Associado WHERE Id = @idAssociado";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {                    

                    command.Parameters.AddWithValue("@idAssociado", idAssociado);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        if (reader.Read()) {
                            associado = new Associado {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                Cpf = reader["Cpf"].ToString(),
                                DataNascimento = Convert.ToDateTime(reader["DataNascimento"])
                            };
                        }
                    }
                }
            }
            return associado;
        }

        public async Task<List<Associado>> GetAssociadosByIdEmpresaAsync(int idEmpresa) {

            List<Associado> AssociadoList = new List<Associado>();

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT A.Id, A.Nome, A.Cpf, A.DataNascimento " +
                                "FROM Associado A JOIN EmpresaAssociado EA " +
                                "ON A.Id = EA.IdAssociado " +
                                "WHERE IdEmpresa = @idEmpresa";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {

                    command.Parameters.AddWithValue("@idEmpresa", idEmpresa);


                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        while (reader.Read()) {
                            Associado associado = new Associado {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                Cpf = reader["Cpf"].ToString(),
                                DataNascimento = Convert.ToDateTime(reader["DataNascimento"])
                            };

                            AssociadoList.Add(associado);
                        }
                    }
                }

            }
            return await Task.FromResult(AssociadoList);
        }

        public async Task<List<Associado>> SearchAssociadosAsync(string nome, string cpf, DateTime? dataNascimento) {
            List<Associado> AssociadoList = new List<Associado>();

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT Id, Nome, Cpf, DataNascimento FROM Associado";

                string tempQuery = "";
                if (!string.IsNullOrEmpty(nome)) {
                    tempQuery += $" Nome LIKE @nome OR";
                } 
                if (!string.IsNullOrEmpty(cpf)) {
                    tempQuery += $" Cpf LIKE @cpf OR";
                } 
                if (dataNascimento != null) {
                    tempQuery += $" DataNascimento LIKE @dataNascimento OR";
                }

                if (!String.IsNullOrEmpty(tempQuery)) {
                    tempQuery = " WHERE " + tempQuery.Substring(0, tempQuery.Length - 2);
                }
                sqlQuery += tempQuery;

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    if (!string.IsNullOrEmpty(nome)) {
                        command.Parameters.AddWithValue("@nome", "%" + nome + "%");
                    }
                    if (!string.IsNullOrEmpty(cpf)) {
                        command.Parameters.AddWithValue("@cpf", "%" + cpf + "%");
                    }
                    if (dataNascimento != null) {
                        command.Parameters.AddWithValue("@dataNascimento", dataNascimento);
                    }

                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        while (reader.Read()) {
                            Associado associado = new Associado {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                Cpf = reader["Cpf"].ToString(),
                                DataNascimento = Convert.ToDateTime(reader["DataNascimento"])
                            };

                            AssociadoList.Add(associado);
                        }
                    }
                }

            }
            return AssociadoList;
        }

        public async Task<Associado> UpdateAssociadoAsync(AssociadoAlteracao associado) {
            Associado AssociadoRetorno = null;
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "UPDATE Associado SET Nome = @nome, Cpf = @cpf, DataNascimento = @dataNascimento WHERE Id = @idAssociado";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@idAssociado", associado.Id);
                    command.Parameters.AddWithValue("@nome", associado.Nome);
                    command.Parameters.AddWithValue("@cpf", associado.Cpf);
                    command.Parameters.AddWithValue("@dataNascimento", associado.DataNascimento);

                    int modified = Convert.ToInt32(await command.ExecuteScalarAsync());
                    if (connection.State == System.Data.ConnectionState.Open)
                        connection.Close();

                    //retorno da associado atualizado
                    AssociadoRetorno = new Associado() {
                        Id = associado.Id,
                        Cpf = associado.Cpf,
                        Nome = associado.Nome,
                        DataNascimento = associado.DataNascimento,
                    };
                }
            }
            return AssociadoRetorno;
        }
    }
}