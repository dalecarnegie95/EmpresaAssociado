using System.Web.Http;
using WebActivatorEx;
using EmpresaAssociado;
using Swashbuckle.Application;
using System.Linq;

namespace EmpresaAssociado {
    public class SwaggerConfig {
        public static void Register() {
            var thisAssembly = typeof(SwaggerConfig).Assembly;

            GlobalConfiguration.Configuration
                .EnableSwagger(c => {
                    c.SingleApiVersion("v1", "EmpresaAssociado");
                    c.IncludeXmlComments(GetXmlCommentsPath());
                    c.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());
                })
                .EnableSwaggerUi(c => {

                });
        }
        protected static string GetXmlCommentsPath() {
            return System.String.Format(@"{0}\bin\EmpresaAssociado.XML", System.AppDomain.CurrentDomain.BaseDirectory);
        }
    }
}
