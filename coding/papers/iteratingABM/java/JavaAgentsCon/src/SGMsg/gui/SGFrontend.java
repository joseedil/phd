package SGMsg.gui;

import SGMsg.agent.SGAgent;
import agent.ISimulationObserver;

import javax.swing.*;
import java.awt.*;
import java.util.LinkedHashMap;
import java.util.List;

/**
 * Created by jonathan on 05/12/16.
 */
public class SGFrontend extends JFrame implements ISimulationObserver<SGAgent> {
    private SGRenderer renderer;
    private int sleepMs;

    public SGFrontend(int cols, int rows, int sleep ) {
        super("Spatial Game Con");

        this.renderer = new SGRenderer(cols, rows);

        this.sleepMs = sleep;

        this.setDefaultCloseOperation( EXIT_ON_CLOSE );
        this.setContentPane( renderer );
        this.setSize( new Dimension( 1000, 1000 ));
        this.setVisible(true);
    }

    @Override
    public boolean simulationStep(LinkedHashMap<Integer, SGAgent> as) {
        this.renderer.render(as);

        try {
            Thread.sleep( this.sleepMs );
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        return true;
    }
}
