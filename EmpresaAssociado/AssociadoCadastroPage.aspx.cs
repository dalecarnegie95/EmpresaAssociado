using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EmpresaAssociado {
    public partial class AssociadoCadastroPage : System.Web.UI.Page {
        protected void Page_Load(object sender, EventArgs e) {

        }

        protected void btnAlteraPagina_Click(object sender, EventArgs e) {
            Response.Redirect("EmpresaCadastroPage.aspx");
        }
    }
}