using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EmpresaAssociado.Models {
    public class EmpresaCadastro {        
        public string Nome { get; set; }
        public string CNPJ { get; set; }
        public List<int> IdsAssociadosAdicionar { get; set; }
    }
}