import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import javax.jms.*;
import org.apache.activemq.ActiveMQConnectionFactory;

public class MessageServlet extends HttpServlet {
    
    private static final String BROKER_URL = "tcp://localhost:61616";
    private static final String QUEUE_NAME = "test.queue";

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        try {
            ActiveMQConnectionFactory factory = new ActiveMQConnectionFactory(BROKER_URL);
            Connection connection = factory.createConnection();
            connection.start();

            Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
            Queue queue = session.createQueue(QUEUE_NAME);
            MessageProducer producer = session.createProducer(queue);

            TextMessage message = session.createTextMessage("Hello from servlet!");
            producer.send(message);

            out.println("Message sent successfully.");

            producer.close();
            session.close();
            connection.close();
        } catch (Exception e) {
            e.printStackTrace(out);
        }
    }
}