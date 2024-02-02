using EmpresaAssociado.Models;
using EmpresaAssociado.Service;
using System;
using System.Threading.Tasks;
using System.Web.Http;
using static EmpresaAssociado.Service.EmpresaService;

namespace EmpresaAssociado.Controllers {
    [RoutePrefix("api/Empresa")]
    public class EmpresaController : ApiController {
        private readonly EmpresaService _EmpresaService;

        public EmpresaController() {
            _EmpresaService = new EmpresaService();
        }
        /// <summary>
        /// Busca empresas por nome e cnpj
        /// </summary>
        [HttpGet]
        [Route("")]
        public async Task<IHttpActionResult> GetAllEmpresas(string nome = null, string cnpj = null) {
            try {                
                var empresas = await _EmpresaService.GetEmpresasAsync(nome, cnpj);
                return Ok(empresas); 
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }

        /// <summary>
        /// Busca uma Empresa por ID
        /// </summary>
        [HttpGet]
        [Route("{id}")]
        public async Task<IHttpActionResult> GetEmpresaById(int id) {
            try {
                var empresa = await _EmpresaService.GetEmpresasByIdAsync(id);
                return Ok(empresa); 
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }

        /// <summary>
        /// Cadsatra uma Empresa
        /// </summary>
        [HttpPost]
        [Route("")]
        public async Task<IHttpActionResult> CadastraEmpresa([FromBody] EmpresaCadastro empresas) {
            try {
                var empresasRetorno = await _EmpresaService.AddEmpresaAsync(empresas);
                return Ok(empresasRetorno);
            } catch(RegisteredCompanyException ex) {
                return BadRequest(ex.Message);
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }

        /// <summary>
        /// Atualiza a Empresa
        /// </summary>
        [HttpPut]
        [Route("")]
        public async Task<IHttpActionResult> AlteraEmpresa([FromBody] EmpresaAlteracao empresa) {
            try {
                var empresasRetorno = await _EmpresaService.UpdateEmpresaAsync(empresa);
                return Ok(empresasRetorno); 
            } catch (UnregisteredCompanyException ex) {
                return BadRequest(ex.Message);
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
       
        }

        /// <summary>
        /// Exclui uma Empresa
        /// </summary>
        [HttpDelete]
        [Route("{id}")]
        public async Task<IHttpActionResult> DeleteEmpresaById(int id) {
            try {
                await _EmpresaService.DeleteEmpresaAsync(id);
                return Ok(); 
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }
    }
}