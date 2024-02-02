using EmpresaAssociado.DataAccess.Repositories;
using EmpresaAssociado.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace EmpresaAssociado.Service {
    public class AssociadoService {
        private readonly IEmpresaRepository _empresaRepository;
        private readonly IAssociadoRepository _associadoRepository;

        public AssociadoService() {
            _empresaRepository = new EmpresaRepository();
            _associadoRepository = new AssociadoRepository();
        }

        public async Task<List<Associado>> GetAssociadosAsync(string nome, string cpf, DateTime? dataNascimento) {
            var associadoRetorno = await _associadoRepository.SearchAssociadosAsync(nome, cpf, dataNascimento);
            foreach (var assoRet in associadoRetorno) {
                assoRet.Empresas = await _empresaRepository.GetEmpresasByIdAssociadoAsync(assoRet.Id);
            }
            return associadoRetorno;
        }

        public async Task<Associado> GetAssociadosByIdAsync(int idAssociado) {
            var associadoRetorno = await _associadoRepository.GetAssociadoByIdAsync(idAssociado);
            if (associadoRetorno != null)
                associadoRetorno.Empresas = await _empresaRepository.GetEmpresasByIdAssociadoAsync(associadoRetorno.Id);
            return associadoRetorno;
        }

        public async Task<Associado> UpdateAssociadoAsync(AssociadoAlteracao associadoAlteracao) {

            Associado associadoRetorno = null;
            var tempAssociado = await _associadoRepository.GetAssociadoByIdAsync(associadoAlteracao.Id);

            if (tempAssociado != null) {
                //Associado existente
                var assoAtualizado = await _associadoRepository.UpdateAssociadoAsync(associadoAlteracao);
                associadoRetorno = assoAtualizado;

                var empresasAtuais = await _empresaRepository.GetEmpresasByIdAssociadoAsync(associadoRetorno.Id);

                if (associadoAlteracao.IdsEmpresasRemover != null)
                    foreach (var idEmpresa in associadoAlteracao.IdsEmpresasRemover) {
                        // se já existe associação remove
                        if (empresasAtuais.Any(a => a.Id == idEmpresa)) {
                            await _empresaRepository.DeleteVinculoAssociadoEmpresaAsync(idEmpresa, associadoRetorno.Id);
                            empresasAtuais.Remove(empresasAtuais.FirstOrDefault(a => a.Id == idEmpresa));
                        }
                    }

                foreach (var idEmpresa in associadoAlteracao.IdsEmpresasAdicionar) {
                    //Verifica se Associado Existe e se já não está adicionado
                    var tempEmpresa = _empresaRepository.GetEmpresaByIdAsync(idEmpresa);
                    if (tempEmpresa != null && !empresasAtuais.Any(a => a.Id == idEmpresa)) {
                        await _empresaRepository.AddVinculoAssociadosEmEmpresaAsync(idEmpresa, associadoRetorno.Id);
                    }
                }
                associadoRetorno.Empresas = await _empresaRepository.GetEmpresasByIdAssociadoAsync(associadoRetorno.Id);
            } else {
                throw new UnregisteredMemberException();
            }
            return associadoRetorno;
        }

        public async Task<Associado> AddAssociadoAsync(AssociadoCadastro associadoCadastro) {

            Associado AssociadoRetorno = null;
            var tempAssociado = await _associadoRepository.GetAssociadoByCpfAsync(associadoCadastro.Cpf);

            if (tempAssociado == null) {
                //Associado não existe -> cadastra o associado

                var assoCadastrado = await _associadoRepository.AddAssociadoAsync(associadoCadastro);
                AssociadoRetorno = assoCadastrado;

                foreach (var idEmpresa in associadoCadastro.IdsEmpresasAdicionar) {
                    //Verifica se Empresa Existe
                    var tempEmpresa = await _empresaRepository.GetEmpresaByIdAsync(idEmpresa);
                    if (tempEmpresa != null) {
                        await _empresaRepository.AddVinculoAssociadosEmEmpresaAsync(idEmpresa, AssociadoRetorno.Id);
                    }
                }
                AssociadoRetorno.Empresas = await _empresaRepository.GetEmpresasByIdAssociadoAsync(AssociadoRetorno.Id);
            } else {
                throw new RegisteredMemberException();
            }
            return AssociadoRetorno;
        }

        public async Task DeleteAssociadoAsync(int idAssociado) {
            await _associadoRepository.DeleteVinvuloAssociadoEmpresaAsync(idAssociado);
            await _associadoRepository.DeleteAssociadoAsync(idAssociado);
        }

        #region Exceptions
        public class RegisteredMemberException : Exception {
            public RegisteredMemberException() : base("Associado(a) já cadastrado(a)") {
            }
        }
        public class UnregisteredMemberException : Exception {
            public UnregisteredMemberException() : base("Associado(a) não cadastrado(a)") {
            }
        }
        #endregion

    }
}