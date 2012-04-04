/*
 * 1.0 code.
 */

import java.applet.*;
import java.awt.*;
import java.util.Enumeration;

public class GetApplets extends Applet {
    private TextArea textArea;

    public void init() {
        setLayout(new BorderLayout());

        add("North", new Button("Click to call getApplets()"));

        textArea = new TextArea(5, 40);
        textArea.setEditable(false);
        add("Center", textArea);

        validate();
    }

    public boolean action(Event event, Object o) {
        printApplets();
        return false;
    }

    public String getAppletInfo() {
        return "GetApplets by Kathy Walrath";
    }

    public void printApplets() {
        //Enumeration will contain all applets on this page (including
        //this one) that we can send messages to.
        Enumeration e = getAppletContext().getApplets();

        textArea.appendText("Results of getApplets():\n");

        while (e.hasMoreElements()) {
            Applet applet = (Applet)e.nextElement();
            String info = ((Applet)applet).getAppletInfo();
            if (info != null) {
                textArea.appendText("- " + info + "\n");
            } else {
                textArea.appendText("- " + applet.getClass().getName() + "\n");
            } 
        }
        textArea.appendText("________________________\n\n");
    }
}

