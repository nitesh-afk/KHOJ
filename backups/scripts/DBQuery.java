import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBQuery {
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3307/khoj_db", "root", "1234");
            Statement stmt = conn.createStatement();
            
            System.out.println("=== NEIGHBORHOODS ===");
            ResultSet rs = stmt.executeQuery("SELECT neighborhood_id, neighborhood_name, city_id FROM neighborhoods");
            while(rs.next()) {
                System.out.println(rs.getInt("neighborhood_id") + " : " + rs.getString("neighborhood_name"));
            }
            
            System.out.println("=== PROPERTY TYPES ===");
            ResultSet rs2 = stmt.executeQuery("SELECT type_id, type_name FROM property_types");
            while(rs2.next()) {
                System.out.println(rs2.getInt("type_id") + " : " + rs2.getString("type_name"));
            }
            
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
