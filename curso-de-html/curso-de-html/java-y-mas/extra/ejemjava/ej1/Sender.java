/*
 * 1.0 code.
 */

import java.applet.*;
import java.awt.*;
import java.util.Enumeration;

public class Sender extends Applet {
    private String myName;
    private TextField nameField;
    private TextArea status;

    public void init() {
        GridBagLayout gridBag = new GridBagLayout();
        GridBagConstraints c = new GridBagConstraints();

        setLayout(gridBag);

        Label receiverLabel = new Label("Receiver name:", Label.RIGHT);
        gridBag.setConstraints(receiverLabel, c);
        add(receiverLabel);

        nameField = new TextField(getParameter("RECEIVERNAME"), 10);
        c.fill = GridBagConstraints.HORIZONTAL;
        gridBag.setConstraints(nameField, c);
        add(nameField);

        Button button = new Button("Send message");
        c.gridwidth = GridBagConstraints.REMAINDER; //end row
        c.anchor = GridBagConstraints.WEST; //stick to the text field
        c.fill = GridBagConstraints.NONE; //keep the button small
        gridBag.setConstraints(button, c);
        add(button);

        status = new TextArea(5, 60);
        status.setEditable(false);
        c.anchor = GridBagConstraints.CENTER; //reset to the default
        c.fill = GridBagConstraints.BOTH; //make this big
        c.weightx = 1.0;
        c.weighty = 1.0;
        gridBag.setConstraints(status, c);
        add(status);

        myName = getParameter("NAME");
        Label senderLabel = new Label("(My name is " + myName + ".)", 
                                Label.CENTER);
        c.weightx = 0.0;
        c.weighty = 0.0;
        gridBag.setConstraints(senderLabel, c);
        add(senderLabel);

        validate();
    }

    public boolean action(Event event, Object o) {
        Applet receiver = null;
        String receiverName = nameField.getText(); //Get name to search for.
        receiver = getAppletContext().getApplet(receiverName);
        if (receiver != null) {
	    //Use the instanceof operator to make sure the applet
	    //we found is a Receiver object.
            if (!(receiver instanceof Receiver)) {
                status.appendText("Found applet named "
                                  + receiverName + ", "
                                  + "but it's not a Receiver object.\n");
            } else {
                status.appendText("Found applet named "
                                  + receiverName + ".\n"
                                  + "  Sending message to it.\n");
		//Cast the receiver to be a Receiver object
		//(instead of just an Applet object) so that the
		//compiler will let us call a Receiver method.
                ((Receiver)receiver).processRequestFrom(myName);
            }
        } else {
            status.appendText("Couldn't find any applet named "
                              + receiverName + ".\n");
        }
        return false;

    }

    public Insets insets() {
        return new Insets(3,3,3,3);
    }

    public void paint(Graphics g) {
        g.drawRect(0, 0, size().width - 1, size().height - 1);
    }

    public String getAppletInfo() {
        return "Sender by Kathy Walrath";
    }
}
