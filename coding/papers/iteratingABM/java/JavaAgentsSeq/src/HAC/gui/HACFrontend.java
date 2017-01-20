package HAC.gui;

import HAC.agent.HACAgent;
import agent.ISimulationObserver;

import javax.swing.*;
import java.awt.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.util.List;

/**
 * Created by jonathan on 05/12/16.
 */
public class HACFrontend extends JFrame implements ISimulationObserver<HACAgent>, WindowListener {
    private HACRenderer renderer;
    private boolean continueSimulation;
    private long lastUpdate;

    public HACFrontend(int agentSize, boolean visible) {
        super("Heroes & Cowards Seq");

        this.renderer = new HACRenderer(agentSize);
        this.continueSimulation = true;
        this.lastUpdate = System.currentTimeMillis();

        this.setDefaultCloseOperation( EXIT_ON_CLOSE );
        this.addWindowListener( this );
        this.setContentPane( renderer );
        this.setSize( new Dimension( 1000, 1000 ));
        this.setVisible(visible);

        this.addKeyListener(new KeyListener() {
            @Override
            public void keyTyped(KeyEvent e) {

            }

            @Override
            public void keyPressed(KeyEvent e) {

            }

            @Override
            public void keyReleased(KeyEvent e) {
                if (e.getKeyCode() == KeyEvent.VK_SPACE) {
                    HACFrontend.this.renderer.toggleRenderMode();
                } else if (e.getKeyCode() == KeyEvent.VK_ESCAPE) {
                    HACFrontend.this.renderer.resetAgentSelection();
                } else if (e.getKeyCode() == KeyEvent.VK_F) {
                    HACFrontend.this.renderer.switchAgentSelection(false);
                } else if (e.getKeyCode() == KeyEvent.VK_E) {
                    HACFrontend.this.renderer.switchAgentSelection(true);
                }
            }
        });
    }

    @Override
    public double startSimulation() {
        this.lastUpdate = System.currentTimeMillis();
        return 0;
    }

    @Override
    public double getDt() {
        long curr = System.currentTimeMillis();
        return (double) (curr - this.lastUpdate) / 1000.0;
    }

    @Override
    public boolean simulationStep(List<HACAgent> as) {
        this.renderer.render(as);
        this.lastUpdate = System.currentTimeMillis();

        return this.continueSimulation;
    }

    @Override
    public void windowOpened(WindowEvent e) {
    }

    @Override
    public void windowClosing(WindowEvent e) {
        this.continueSimulation = false;
    }

    @Override
    public void windowClosed(WindowEvent e) {
    }

    @Override
    public void windowIconified(WindowEvent e) {
    }

    @Override
    public void windowDeiconified(WindowEvent e) {
    }

    @Override
    public void windowActivated(WindowEvent e) {
    }

    @Override
    public void windowDeactivated(WindowEvent e) {
    }
}
