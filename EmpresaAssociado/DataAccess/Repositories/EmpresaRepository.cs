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
    public class EmpresaRepository : IEmpresaRepository {

        private readonly DatabaseManager _dbManager;

        public EmpresaRepository() {
            _dbManager = new DatabaseManager();
        }
        public async Task<Empresa> AddEmpresaAsync(EmpresaCadastro empresa) {
            Empresa empresaRetorno = null;
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "INSERT INTO Empresa (Nome, CNPJ) VALUES (@nome, @cnpj); SELECT SCOPE_IDENTITY()";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@nome", empresa.Nome);
                    command.Parameters.AddWithValue("@cnpj", empresa.CNPJ);

                    int modified = Convert.ToInt32(await command.ExecuteScalarAsync());
                    if (connection.State == System.Data.ConnectionState.Open)
                        connection.Close();

                    //retorno da empresa cadastrada
                    empresaRetorno = new Empresa() {
                        Id = modified,
                        CNPJ = empresa.CNPJ,
                        Nome = empresa.Nome
                    };                    
                }
            }
            return empresaRetorno;
        }
        public async Task<Empresa> GetEmpresaByIdAsync(int idEmpresa) {
            Empresa empresa = null;

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT Id, Nome, CNPJ FROM Empresa WHERE Id = @idEmpresa";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {                    

                    command.Parameters.AddWithValue("@idEmpresa", idEmpresa);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        if (reader.Read()) {
                            empresa = new Empresa {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                CNPJ = reader["CNPJ"].ToString()
                            };
                        }
                    }
                }
            }
            return empresa;
        }
        public async Task<List<Empresa>> SearchEmpresasAsync(string nome, string cnpj) {

            List<Empresa> EmpresaList = new List<Empresa>();

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT Id, Nome, CNPJ FROM Empresa";

                if (!string.IsNullOrEmpty(nome) && !string.IsNullOrEmpty(cnpj)) {
                    sqlQuery += $" WHERE Nome LIKE @nome OR CNPJ LIKE @cnpj";
                } else if (!string.IsNullOrEmpty(nome)) {
                    sqlQuery += $" WHERE Nome LIKE @nome";
                } else if (!string.IsNullOrEmpty(cnpj)) {
                    sqlQuery += $" WHERE CNPJ LIKE @cnpj";
                }
                
                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    if (!string.IsNullOrEmpty(nome)) {
                        command.Parameters.AddWithValue("@nome", "%" + nome + "%");
                    }
                    if (!string.IsNullOrEmpty(cnpj)) {
                        command.Parameters.AddWithValue("@cnpj", "%" + cnpj + "%");
                    }

                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        while (reader.Read()) {
                            Empresa empresa = new Empresa {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                CNPJ = reader["CNPJ"].ToString()
                            };

                            EmpresaList.Add(empresa);
                        }
                    }
                }

            }
            return EmpresaList;
        }
        public async Task DeleteEmpresaAsync(int idEmpresa) {
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "DELETE FROM Empresa WHERE Id = @idEmpresa";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@idEmpresa", idEmpresa);

                    await command.ExecuteNonQueryAsync();
                }
            }
        }
        public async Task<Empresa> GetEmpresaByCNPJAsync(string CNPJ) {
            Empresa empresa = null;

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT Id, Nome, CNPJ FROM Empresa WHERE CNPJ = @cnpj";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {                    

                    command.Parameters.AddWithValue("@cnpj", CNPJ);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        if (reader.Read()) {
                            empresa = new Empresa {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                CNPJ = reader["CNPJ"].ToString()
                            };
                        }
                    }
                }
            }
            return empresa;
        }
        public async Task DeleteVinvuloAssociadoEmpresaAsync(int idEmpresa) {
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "DELETE FROM EmpresaAssociado WHERE IdEmpresa = @idEmpresa";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@idEmpresa", idEmpresa);

                    await command.ExecuteNonQueryAsync();
                }
            }
        }
        public async Task AddVinculoAssociadosEmEmpresaAsync(int idEmpresa, int idAssociado) {
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "INSERT INTO EmpresaAssociado (IdAssociado, IdEmpresa) VALUES (@idAssociado, @idEmpresa)";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@IdAssociado", idAssociado);
                    command.Parameters.AddWithValue("@IdEmpresa", idEmpresa);

                    int modified = await command.ExecuteNonQueryAsync();
                    if (connection.State == System.Data.ConnectionState.Open)
                        connection.Close();
                }
            }
        }
        public async Task DeleteVinculoAssociadoEmpresaAsync(int idEmpresa, int idAssociado) {
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "DELETE FROM EmpresaAssociado WHERE idEmpresa = @idEmpresa AND idAssociado = @idAssociado";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@IdAssociado", idAssociado);
                    command.Parameters.AddWithValue("@IdEmpresa", idEmpresa);

                    int modified = Convert.ToInt32(await command.ExecuteNonQueryAsync());
                    if (connection.State == System.Data.ConnectionState.Open)
                        connection.Close();
                }
            }
        }
        public async Task<Empresa> UpdateEmpresaAsync(EmpresaAlteracao empresa) {
            Empresa empresaRetorno = null;
            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "UPDATE Empresa SET Nome = @nome, CNPJ = @cnpj WHERE Id = @idEmpresa";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {
                    command.Parameters.AddWithValue("@idEmpresa", empresa.Id);
                    command.Parameters.AddWithValue("@nome", empresa.Nome);
                    command.Parameters.AddWithValue("@cnpj", empresa.CNPJ);

                    int modified = Convert.ToInt32(await command.ExecuteScalarAsync());
                    if (connection.State == System.Data.ConnectionState.Open)
                        connection.Close();

                    //retorno da empresa atualizada
                    empresaRetorno = new Empresa() {
                        Id = empresa.Id,
                        CNPJ = empresa.CNPJ,
                        Nome = empresa.Nome
                    };                    
                }
            }
            return empresaRetorno;
        }
        public async Task<List<Empresa>> GetEmpresasByIdAssociadoAsync(int idAssociado) {

            List<Empresa> empresaList = new List<Empresa>();

            using (SqlConnection connection = _dbManager.GetConnection()) {
                await connection.OpenAsync();

                string sqlQuery = "SELECT E.Id, E.Nome, E.CNPJ " +
                                "FROM Empresa E JOIN EmpresaAssociado EA " +
                                "ON E.Id = EA.IdEmpresa " +
                                "WHERE IdAssociado = @idAssociado";

                using (SqlCommand command = new SqlCommand(sqlQuery, connection)) {

                    command.Parameters.AddWithValue("@idAssociado", idAssociado);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync()) {
                        while (reader.Read()) {
                            Empresa empresa = new Empresa {
                                Id = Convert.ToInt32(reader["Id"]),
                                Nome = reader["Nome"].ToString(),
                                CNPJ = reader["CNPJ"].ToString()                                
                            };

                            empresaList.Add(empresa);
                        }
                    }
                }

            }
            return empresaList;
        }
    }
}