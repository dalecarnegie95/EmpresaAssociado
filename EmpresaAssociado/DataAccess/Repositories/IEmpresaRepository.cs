using EmpresaAssociado.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace EmpresaAssociado.DataAccess.Repositories {
    public interface IEmpresaRepository {
        Task<List<Empresa>> SearchEmpresasAsync(string nome, string cnpj);
        Task<Empresa> GetEmpresaByCNPJAsync(string CNPJ);
        Task<Empresa> GetEmpresaByIdAsync(int idEmpresa);
        Task<List<Empresa>> GetEmpresasByIdAssociadoAsync(int idAssociado);
        Task<Empresa> AddEmpresaAsync(EmpresaCadastro empresa);
        Task AddVinculoAssociadosEmEmpresaAsync(int idEmpresa, int idAssociado);
        Task DeleteVinculoAssociadoEmpresaAsync(int idEmpresa, int idAssociado);
        Task<Empresa> UpdateEmpresaAsync(EmpresaAlteracao empresa);
        Task DeleteEmpresaAsync(int idEmpresa);
        Task DeleteVinvuloAssociadoEmpresaAsync(int idEmpresa);
    }
}