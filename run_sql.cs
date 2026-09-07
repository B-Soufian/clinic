using System;
using System.Data.SqlClient;

public class Program {
    public static void Main() {
        string connStr = "Server=tcp:emr-sql-server-fromza.database.windows.net,1433;Initial Catalog=DEV_FromzaEMR_INT;Persist Security Info=False;User ID=soufian;Password=fromza@00;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";
        using (SqlConnection conn = new SqlConnection(connStr)) {
            conn.Open();
            using (SqlCommand cmd = new SqlCommand("SELECT UserName, EmployeeId, Email FROM RBAC_User", conn)) {
                using (SqlDataReader reader = cmd.ExecuteReader()) {
                    Console.WriteLine("Users in DB:");
                    while (reader.Read()) {
                        Console.WriteLine("- " + reader["UserName"] + " (EmpID: " + reader["EmployeeId"] + ")");
                    }
                }
            }
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM EMP_Employee", conn)) {
                Console.WriteLine("Total Employees: " + cmd.ExecuteScalar());
            }
        }
    }
}
