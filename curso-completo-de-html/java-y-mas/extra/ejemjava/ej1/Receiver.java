/*
 * 1.0 code.
 */

import java.applet.*;
import java.awt.*;

public class Receiver extends Applet {
    private final String waitingMessage = "Waiting for a message...           ";
    private Label label = new Label(waitingMessage, Label.RIGHT);

    public void init() {
        add(label);
        add(new Button("Clear"));
        add(new Label("(My name is " + getParameter("name") + ".)", 
                      Label.LEFT)); 
        validate();
    }

    public boolean action(Event event, Object o) {
        label.setText(waitingMessage);
        repaint();
        return false;
    }

    public void processRequestFrom(String senderName) {
        label.setText("Received message from " + senderName + "!");
        repaint();
    }

    public void paint(Graphics g) {
        g.drawRect(0, 0, size().width - 1, size().height - 1);
    }

    public String getAppletInfo() {
        return "Receiver (named " + getParameter("name") + ") by Kathy Walrath";
    }
}

