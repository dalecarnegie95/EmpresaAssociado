using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EmpresaAssociado.Models {
    public class AssociadoAlteracao {
        public int Id { get; set; }
        public string Nome { get; set; }
        public string Cpf { get; set; }
        public DateTime DataNascimento { get; set; }
        public List<int> IdsEmpresasAdicionar { get; set; }
        public List<int> IdsEmpresasRemover { get; set; }
    }
}