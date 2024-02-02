using EmpresaAssociado.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace EmpresaAssociado.DataAccess.Repositories {
    public interface IAssociadoRepository {
        Task<List<Associado>> SearchAssociadosAsync(string nome, string cpf, DateTime? dataNascimento);
        Task<Associado> GetAssociadoByCpfAsync(string cpf);
        Task<Associado> GetAssociadoByIdAsync(int idAssociado);
        Task<List<Associado>> GetAssociadosByIdEmpresaAsync(int idEmpresa);
        Task<Associado> AddAssociadoAsync(AssociadoCadastro associado);
        Task<Associado> UpdateAssociadoAsync(AssociadoAlteracao associado);
        Task DeleteAssociadoAsync(int idAssociado);
        Task DeleteVinvuloAssociadoEmpresaAsync(int idAssociado);
    }
}