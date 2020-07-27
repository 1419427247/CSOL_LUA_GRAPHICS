import java.awt.*;
import java.awt.datatransfer.Clipboard;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.image.*;
import java.util.HashSet;
import java.awt.datatransfer.*;
import javax.swing.*;

class Frame extends JFrame {
	JPanel pJPanel = new JPanel();
	JTextField textField = new JTextField();
	JButton jButton = new JButton("生成");

	Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();

	public Frame() {
		this.setSize(800, 120);

		jButton.addMouseListener(new MouseListener() {

			@Override
			public void mouseClicked(MouseEvent e) {
				JOptionPane.showMessageDialog(null, "已复制到剪贴板", "提示", JOptionPane.INFORMATION_MESSAGE);
				String str = textField.getText();

				HashSet<Character> set = new HashSet<Character>();
				for (Character character : str.toCharArray()) {
					set.add(character);
				}

				StringBuffer buff = new StringBuffer();
				Font font = new Font("黑体", -2, 14);
				int Width = 16;
				int Height = 16;

				for (final Character ca : set) {
					final BufferedImage image = new BufferedImage(Width, Height, BufferedImage.TYPE_BYTE_GRAY);
					final Graphics2D g = (Graphics2D) image.getGraphics();
					final FontMetrics metrics = g.getFontMetrics(font);
					g.setFont(font);

					final int x = (Width - metrics.stringWidth(ca.toString())) / 2;
					final int y = ((Height - metrics.getHeight()) / 2) + metrics.getAscent();

					g.drawString(ca.toString(), x, y);

					final int[][] bitmap = new int[image.getHeight()][image.getWidth()];

					for (int i = 0; i < image.getHeight(); i++) {
						for (int j = 0; j < image.getWidth(); j++) {
							bitmap[i][j] = image.getRGB(j, i) == -16777216 ? ' ' : 'O';
						}
					}
					buff.append("Font[\'" + ca + "\']={");
					for (int R = 0; R < bitmap.length; R++) {
						for (int C = 0; C < bitmap[R].length; C++) {
							if (bitmap[R][C] == 'O') {
								int r = 0;
								int c = 0;
								while (R + r < bitmap.length) {
									if (bitmap[R + r][C] != 'O') {
										break;
									}
									r++;
								}
								while (C + c < bitmap[0].length) {
									if (bitmap[R][C + c] != 'O') {
										break;
									}
									c++;
								}
								if (r > c) {
									for (int i = 0; i < r; i++) {
										bitmap[R + i][C] = ' ';
									}
									buff.append(C + "," + R + "," + 1 + "," + r + ",");
								} else {
									for (int i = 0; i < c; i++) {
										bitmap[R][C + i] = ' ';
									}
									buff.append(C + "," + R + "," + c + "," + 1 + ",");
								}
							}
						}
					}
					buff.deleteCharAt(buff.length() - 1);
					buff.append("}\r\n");
				}

				clipboard.setContents(new StringSelection(buff.toString()), null);
			}

			@Override
			public void mousePressed(MouseEvent e) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mouseReleased(MouseEvent e) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mouseEntered(MouseEvent e) {
				// TODO Auto-generated method stub

			}

			@Override
			public void mouseExited(MouseEvent e) {
				// TODO Auto-generated method stub

			}
		});

		pJPanel.setLayout(null);
		this.add(pJPanel);

		textField.setBounds(0, 0, 800, 50);
		jButton.setBounds(350, 50, 100, 30);
		pJPanel.add(textField);
		pJPanel.add(jButton);

		this.setTitle("字体生成器");
		this.setResizable(false);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setVisible(true);
	}
}

public class Program {
	public static void main(final String[] args) {
		Frame f = new Frame();
	}
}
