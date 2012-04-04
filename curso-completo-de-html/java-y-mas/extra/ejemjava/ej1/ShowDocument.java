/*
 * 1.0 code.
 */

import java.applet.*;
import java.awt.*;
import java.net.URL;
import java.net.MalformedURLException;

public class ShowDocument extends Applet {
    URLWindow urlWindow;

    public void init() {
        Button button = new Button("Bring up URL window");
        add(button);
        validate();

        urlWindow = new URLWindow(getAppletContext());
        urlWindow.pack();
    }

    public void destroy() {
        urlWindow.hide();
        urlWindow = null;
    }

    public boolean action(Event event, Object o) {
        urlWindow.show();
        return true;
    }
}

class URLWindow extends Frame {
    TextField urlField;
    Choice choice;
    AppletContext appletContext;

    public URLWindow(AppletContext appletContext) {
        super("Show a Document!");

        this.appletContext = appletContext;

        GridBagLayout gridBag = new GridBagLayout();
        GridBagConstraints c = new GridBagConstraints();
        setLayout(gridBag);

        Label label1 = new Label("URL of document to show:", Label.RIGHT);
        gridBag.setConstraints(label1, c);
        add(label1);

        urlField = new TextField("http://java.sun.com/", 40);
        c.gridwidth = GridBagConstraints.REMAINDER;
        c.fill = GridBagConstraints.HORIZONTAL;
        c.weightx = 1.0;
        gridBag.setConstraints(urlField, c);
        add(urlField);

        Label label2 = new Label("Window/frame to show it in:", Label.RIGHT);
        c.gridwidth = 1;
        c.weightx = 0.0;
        gridBag.setConstraints(label2, c);
        add(label2);

        choice = new Choice();
        choice.addItem("(browser's choice)"); //don't specify
        choice.addItem("My Personal Window"); //a window named "My Personal Window"
        choice.addItem("_blank"); //a new, unnamed window
        choice.addItem("_self"); 
        choice.addItem("_parent"); 
        choice.addItem("_top"); //the Frame that contained this applet
        c.fill = GridBagConstraints.NONE;
        c.gridwidth = GridBagConstraints.REMAINDER;
        c.anchor = GridBagConstraints.WEST;
        gridBag.setConstraints(choice, c);
        add(choice);

        Button button = new Button("Show document");
        c.weighty = 1.0;
        c.ipadx = 10;
        c.ipady = 10;
        c.insets = new Insets(5,0,0,0);
        c.anchor = GridBagConstraints.SOUTH;
        gridBag.setConstraints(button, c);
        add(button);
    }

    public boolean handleEvent(Event event) {
        if (event.id == Event.WINDOW_DESTROY) {
            hide();
            return true;
        }
        return super.handleEvent(event);
    } 

    public boolean action(Event event, Object o) {
        if ((event.target instanceof Button) |
            (event.target instanceof TextField)) {
            String urlString = urlField.getText();
            URL url = null;
            try {
                url = new URL(urlString);
            } catch (MalformedURLException e) {
                System.out.println("Malformed URL: " + urlString);
                return true;
            }

            if (url != null) {
                if (choice.getSelectedIndex() == 0) {
                    appletContext.showDocument(url);
                } else {
                    appletContext.showDocument(url, choice.getSelectedItem());
                }
            }
        }
        return true;
    }
}

