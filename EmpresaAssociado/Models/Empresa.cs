using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EmpresaAssociado.Models {
    public class Empresa {
        public int Id { get; set; }
        public string Nome { get; set; }
        public string CNPJ { get; set; }
        public List<Associado> Associados { get; set; }
    }
}