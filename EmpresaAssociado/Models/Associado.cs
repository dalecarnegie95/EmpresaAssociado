using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace EmpresaAssociado.Models {
    public class Associado {
        public int Id { get; set; }
        public string Nome { get; set; }
        public string Cpf { get; set; }
        public DateTime DataNascimento { get; set; }
        public List<Empresa> Empresas { get; set; }
    }
}