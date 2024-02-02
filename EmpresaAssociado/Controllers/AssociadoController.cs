using EmpresaAssociado.Models;
using EmpresaAssociado.Service;
using System;
using System.Threading.Tasks;
using System.Web.Http;
using static EmpresaAssociado.Service.AssociadoService;

namespace EmpresaAssociado.Controllers {
    [RoutePrefix("api/Associado")]
    public class AssociadoController : ApiController {
        private readonly AssociadoService _AssociadoService;

        public AssociadoController() {
            _AssociadoService = new AssociadoService();
        }
        /// <summary>
        /// Busca associados por nome, cpf, data nascimento
        /// </summary>
        [HttpGet]
        [Route("")]
        public async Task<IHttpActionResult> GetAllAssociados(string nome = null, string cpf = null, DateTime? dataNascimento = null) {
            try {                
                var associados = await _AssociadoService.GetAssociadosAsync(nome, cpf, dataNascimento);
                return Ok(associados); 
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }

        /// <summary>
        /// Busca um Associado por ID
        /// </summary>
        [HttpGet]
        [Route("{id}")]
        public async Task<IHttpActionResult> GetAssociadoById(int id) {
            try {
                var associado = await _AssociadoService.GetAssociadosByIdAsync(id);
                return Ok(associado); 
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }

        /// <summary>
        /// Cadsatra um Associado
        /// </summary>
        [HttpPost]
        [Route("")]
        public async Task<IHttpActionResult> CadastraAssociado([FromBody] AssociadoCadastro associado) {
            try {
                var AssociadoRetorno = await _AssociadoService.AddAssociadoAsync(associado);
                return Ok(AssociadoRetorno);
            } catch(RegisteredMemberException ex) {
                return BadRequest(ex.Message);
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }

        /// <summary>
        /// Atualiza um associado
        /// </summary>
        [HttpPut]
        [Route("")]
        public async Task<IHttpActionResult> AlteraAssociado([FromBody] AssociadoAlteracao associado) {
            try {
                var associadoRetorno = await _AssociadoService.UpdateAssociadoAsync(associado);
                return Ok(associadoRetorno); 
            } catch (UnregisteredMemberException ex) {
                return InternalServerError(ex);
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
       
        }

        /// <summary>
        /// Exclui um Associado
        /// </summary>
        [HttpDelete]
        [Route("{id}")]
        public async Task<IHttpActionResult> DeleteAssociadoById(int id) {
            try {
                await _AssociadoService.DeleteAssociadoAsync(id);
                return Ok(); 
            } catch (Exception ex) {
                return InternalServerError(new Exception("Erro interno do servidor"));
            }
        }
    }
}