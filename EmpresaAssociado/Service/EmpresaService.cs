using EmpresaAssociado.DataAccess.Repositories;
using EmpresaAssociado.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace EmpresaAssociado.Service {
    public class EmpresaService {
        private readonly IEmpresaRepository _empresaRepository;
        private readonly IAssociadoRepository _associadoRepository;

        public EmpresaService() {
            _empresaRepository = new EmpresaRepository();
            _associadoRepository = new AssociadoRepository();
        }

        public async Task<List<Empresa>> GetEmpresasAsync(string nome, string cnpj) {
            var empresasRetorno = await _empresaRepository.SearchEmpresasAsync(nome, cnpj);
            foreach (var empRet in empresasRetorno) {
                empRet.Associados = await _associadoRepository.GetAssociadosByIdEmpresaAsync(empRet.Id);
            }
            return empresasRetorno;
        }

        public async Task<Empresa> GetEmpresasByIdAsync(int idEmpresa) {
            var empresaRetorno = await _empresaRepository.GetEmpresaByIdAsync(idEmpresa);
            if (empresaRetorno != null)
                empresaRetorno.Associados = await _associadoRepository.GetAssociadosByIdEmpresaAsync(empresaRetorno.Id);
            return empresaRetorno;
        }

        public async Task<Empresa> UpdateEmpresaAsync(EmpresaAlteracao empresaAlteracao) {

            Empresa empresasRetorno = null;
            var tempEmpresa = await _empresaRepository.GetEmpresaByIdAsync(empresaAlteracao.Id);

            if (tempEmpresa != null) {
                //Empresa existente
                var empAtualizada = await _empresaRepository.UpdateEmpresaAsync(empresaAlteracao);
                empresasRetorno = empAtualizada;

                var associadosAtuais = await _associadoRepository.GetAssociadosByIdEmpresaAsync(empresasRetorno.Id);

                foreach (var idAssociado in empresaAlteracao.IdsAssociadosRemover) {
                    // se já existe associação remove
                    if (associadosAtuais.Any(a => a.Id == idAssociado)) {
                        await _empresaRepository.DeleteVinculoAssociadoEmpresaAsync(empresasRetorno.Id, idAssociado);
                        associadosAtuais.Remove(associadosAtuais.FirstOrDefault(a => a.Id == idAssociado));
                    }
                }

                foreach (var idAssociado in empresaAlteracao.IdsAssociadosAdicionar) {
                    //Verifica se Associado Existe e se já não está adicionado
                    var tempAssociado = _associadoRepository.GetAssociadoByIdAsync(idAssociado);
                    if (tempAssociado != null && !associadosAtuais.Any(a => a.Id == idAssociado)) {
                        await _empresaRepository.AddVinculoAssociadosEmEmpresaAsync(empresasRetorno.Id, idAssociado);
                    }
                }
                empresasRetorno.Associados = await _associadoRepository.GetAssociadosByIdEmpresaAsync(empresasRetorno.Id);
            } else {
                throw new UnregisteredCompanyException();
            }
            return empresasRetorno;
        }

        public async Task<Empresa> AddEmpresaAsync(EmpresaCadastro empresaCadastro) {

            Empresa empresasRetorno = null;
            var tempEmpresa = await _empresaRepository.GetEmpresaByCNPJAsync(empresaCadastro.CNPJ);

            if (tempEmpresa == null) {
                //Empresa não existe -> cadastra a empresa

                var empCadastrada = await _empresaRepository.AddEmpresaAsync(empresaCadastro);
                empresasRetorno = empCadastrada;

                if (empresaCadastro.IdsAssociadosAdicionar != null)
                    foreach (var idAssociado in empresaCadastro.IdsAssociadosAdicionar) {
                        //Verifica se Associado Existe
                        var tempAssociado = _associadoRepository.GetAssociadoByIdAsync(idAssociado);
                        if (tempAssociado != null) {
                            await _empresaRepository.AddVinculoAssociadosEmEmpresaAsync(empresasRetorno.Id, idAssociado);
                        }
                    }
                empresasRetorno.Associados = await _associadoRepository.GetAssociadosByIdEmpresaAsync(empresasRetorno.Id);
            } else {
                throw new RegisteredCompanyException();
            }
            return empresasRetorno;
        }

        public async Task DeleteEmpresaAsync(int idEmpresa) {
            await _empresaRepository.DeleteVinvuloAssociadoEmpresaAsync(idEmpresa);
            await _empresaRepository.DeleteEmpresaAsync(idEmpresa);
        }

        #region Exceptions
        public class RegisteredCompanyException : Exception {
            public RegisteredCompanyException() : base("Empresa já cadastrada") {
            }
        }
        public class UnregisteredCompanyException : Exception {
            public UnregisteredCompanyException() : base("Empresa não cadastrada") {
            }
        }
        #endregion

    }
}