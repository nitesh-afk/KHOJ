import org.mindrot.jbcrypt.BCrypt;

public class HashGen {
    public static void main(String[] args) {
        String hashed = BCrypt.hashpw("admin12345678", BCrypt.gensalt());
        System.out.println("HASH:" + hashed);
    }
}
