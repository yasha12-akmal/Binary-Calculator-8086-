package binarycal;
 
import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JTextField;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JOptionPane;
import java.awt.Font;
import java.awt.GridLayout;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
 
public class BinaryCalculatorGUI extends JFrame implements ActionListener {
 
    JTextField txtFirst, txtSecond, txtResult;
    JButton btnAdd, btnSub, btnMul, btnDiv, btnExp, btnFact;
    JButton btnAnd, btnOr, btnNot, btn1s, btn2s, btnClear, btnExit;
 
    public BinaryCalculatorGUI() {
        setTitle("Binary Calculator - COAL Project");
        setSize(520, 480);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
 
        // Title Label
        JLabel title = new JLabel("SIMPLE BINARY CALCULATOR (CO&AL PROJECT)", JLabel.CENTER);
        title.setFont(new Font("Arial", Font.BOLD, 14));
 
        // Panel with GridLayout
        JPanel panel = new JPanel(new GridLayout(0, 2, 5, 5));
 
        // Input fields
        panel.add(new JLabel("First Binary (4-bit):"));
        txtFirst = new JTextField();
        panel.add(txtFirst);
 
        panel.add(new JLabel("Second Binary (4-bit):"));
        txtSecond = new JTextField();
        panel.add(txtSecond);
 
        // Result field
        panel.add(new JLabel("Result:"));
        txtResult = new JTextField();
        txtResult.setEditable(false);
        panel.add(txtResult);
 
        // Buttons
        btnAdd  = new JButton("Add");
        btnSub  = new JButton("Subtract");
        btnMul  = new JButton("Multiply");
        btnDiv  = new JButton("Divide");
        btnExp  = new JButton("Exponent");
        btnFact = new JButton("Factorial");
        btnAnd  = new JButton("AND");
        btnOr   = new JButton("OR");
        btnNot  = new JButton("NOT");
        btn1s   = new JButton("1's Comp");
        btn2s   = new JButton("2's Comp");
        btnClear = new JButton("Clear");
        btnExit  = new JButton("Exit");
 
        JButton[] buttons = {btnAdd, btnSub, btnMul, btnDiv, btnExp, btnFact,
                             btnAnd, btnOr, btnNot, btn1s, btn2s, btnClear, btnExit};
 
        for (JButton b : buttons) {
            b.addActionListener(this);
            panel.add(b);
        }
 
        add(title, BorderLayout.NORTH);
        add(panel, BorderLayout.CENTER);
    }
 
    // Utility: parse 4-bit binary input
    int parseBinary(String bin) throws Exception {
        if (!bin.matches("[01]{1,4}"))
            throw new Exception("Invalid Binary Input (Max 4 bits)");
        return Integer.parseInt(bin, 2);
    }
 
    // Utility: display as 8-bit binary
    String toBinary(int value) {
        return String.format("%8s", Integer.toBinaryString(value & 0xFF)).replace(' ', '0');
    }
 
    // Handle button clicks
    public void actionPerformed(ActionEvent e) {
        try {
            Object src = e.getSource();
            int a = 0, b = 0, result = 0;
 
            if (src != btnClear && src != btnExit) {
                if (!txtFirst.getText().isEmpty())
                    a = parseBinary(txtFirst.getText());
                if (!txtSecond.getText().isEmpty())
                    b = parseBinary(txtSecond.getText());
            }
 
            if      (src == btnAdd)  result = a + b;
            else if (src == btnSub)  result = a - b;
            else if (src == btnMul)  result = a * b;
            else if (src == btnDiv) {
                if (b == 0) throw new Exception("Division by Zero");
                result = a / b;
            }
            else if (src == btnExp) {
                result = 1;
                for (int i = 0; i < b; i++) result *= a;
            }
            else if (src == btnFact) {
                result = 1;
                for (int i = 1; i <= a; i++) result *= i;
            }
            else if (src == btnAnd)  result = a & b;
            else if (src == btnOr)   result = a | b;
            else if (src == btnNot)  result = (~a) & 0x0F;
            else if (src == btn1s)   result = (~a) & 0x0F;
            else if (src == btn2s)   result = ((~a) + 1) & 0x0F;
            else if (src == btnClear) {
                txtFirst.setText("");
                txtSecond.setText("");
                txtResult.setText("");
                return;
            }
            else if (src == btnExit) System.exit(0);
 
            txtResult.setText(toBinary(result));
 
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(this, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }
 
    public static void main(String[] args) {
        new BinaryCalculatorGUI().setVisible(true);
    }
}
 