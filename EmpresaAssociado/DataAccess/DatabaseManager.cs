using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace EmpresaAssociado.DataAccess {
    public class DatabaseManager {
        private readonly string connectionString;

        public DatabaseManager() {
            connectionString = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        }

        public SqlConnection GetConnection() {
            return new SqlConnection(connectionString);
        }
    }
}