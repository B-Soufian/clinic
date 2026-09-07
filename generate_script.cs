using System;
using System.IO;
using FromzaEMR.DalLayer;
using System.Data.Entity.Infrastructure;

public class Program {
    public static void Main() {
        var db = new SystemAdminDbContext("Server=tcp:dummy");
        var script = ((IObjectContextAdapter)db).ObjectContext.CreateDatabaseScript();
        File.WriteAllText("admin_tables.sql", script);
    }
}
