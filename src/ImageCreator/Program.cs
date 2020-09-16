using System;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Drawing;
using System.Drawing.Imaging;
using System.ComponentModel;
using System.Text;
namespace Project
{
    class MyForm : Form
    {
        OpenFileDialog openFileDialog = new OpenFileDialog();
        public MyForm()
        {
            this.SetBounds(0, 0, 800, 600);
            this.FormBorderStyle = FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;

            this.Text = "iPad水晶的图形生成器,QQ:1419427247";
            InitializeComponent();
        }
        PictureBox pictureBox_Preview = new PictureBox();
        Button button_Build = new Button();
        Button button_SelectImage = new Button();

        TrackBar trackBar_Quality = new TrackBar();
        TrackBar trackBar_Scale = new TrackBar();
        private void InitializeComponent()
        {
            openFileDialog.Filter = "图片文件(*.jpg,*.gif,*.bmp,*.png)|*.jpg;*.gif;*.bmp;*.png";
            openFileDialog.FileOk += openFileDialog_FileOK;

            pictureBox_Preview.SetBounds(200, 50, 400, 400);
            pictureBox_Preview.Paint += pictureBox_Preview_Paint;
            pictureBox_Preview.MouseUp += pictureBox_Preview_MouseUp;
            this.Controls.Add(pictureBox_Preview);

            button_SelectImage.SetBounds(30, 50, 80, 40);
            button_SelectImage.Click += button_SelectImage_Click;
            button_SelectImage.Text = "选择文件";
            this.Controls.Add(button_SelectImage);

            button_Build.SetBounds(500, 500, 100, 30);
            button_Build.Text = "生成";
            button_Build.Click += button_Build_Click;
            this.Controls.Add(button_Build);

            trackBar_Quality.SetBounds(30, 500, 300, 40);
            trackBar_Quality.Maximum = 25;
            trackBar_Quality.Minimum = 1;
            trackBar_Quality.Value = 1;
            trackBar_Quality.ValueChanged += trackBar_Quality_ValueChanged;
            this.Controls.Add(trackBar_Quality);

            trackBar_Scale.SetBounds(30, 450, 300, 40);
            trackBar_Scale.Maximum = 100;
            trackBar_Scale.Minimum = 1;
            trackBar_Scale.Value = 10;
            trackBar_Scale.ValueChanged += trackBar_Scale_ValueChanged;
            this.Controls.Add(trackBar_Scale);
        }

        Image image;

        int dt = 0;
        float pixivSize = 1;

        private void pictureBox_Preview_Paint(object sender, PaintEventArgs e)
        {
            Graphics graphics = e.Graphics;

            if (image != null)
            {
                FrameDimension frameDimension = new FrameDimension(image.FrameDimensionsList[0]);
                int count = image.GetFrameCount(frameDimension);
                if (dt >= count - 1)
                    dt = 0;
                else if (dt < 0)
                    dt = count - 1;
                image.SelectActiveFrame(frameDimension, dt);

                Bitmap bitmap = new Bitmap(image,
                image.Width / trackBar_Quality.Value,
                image.Height / trackBar_Quality.Value);

                for (int i = 0; i < bitmap.Width; i++)
                    for (int j = 0; j < bitmap.Height; j++)
                        graphics.FillRectangle(new SolidBrush(bitmap.GetPixel(i, j)), i * pixivSize, j * pixivSize, pixivSize, pixivSize);
                bitmap.Dispose();
            }
            graphics.DrawRectangle(Pens.Black, 0, 0, pictureBox_Preview.Width - 1, pictureBox_Preview.Height - 1);
        }
        private void pictureBox_Preview_MouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                dt++;
                pictureBox_Preview.Refresh();

            }
            else if (e.Button == MouseButtons.Right)
            {
                dt--;
                pictureBox_Preview.Refresh();
            }
        }
        private void button_SelectImage_Click(object sender, EventArgs e)
        {
            openFileDialog.ShowDialog();
        }
        private void button_Build_Click(object sender, EventArgs e)
        {

            if (this.image == null)
            {
                System.Windows.Forms.MessageBox.Show("未打开图片");
                return;
            }
            FrameDimension frameDimension = new FrameDimension(image.FrameDimensionsList[0]);
            int boxsize = 0;
            StringBuilder builder = new StringBuilder();

            image.SelectActiveFrame(frameDimension, dt);
            Bitmap bitmap = new Bitmap(image,
            image.Width / trackBar_Quality.Value,
            image.Height / trackBar_Quality.Value);

            Color[,] pix = new Color[bitmap.Height, bitmap.Width];

            for (int j = 0; j < bitmap.Height; j++)
                for (int k = 0; k < bitmap.Width; k++)
                    pix[j, k] = bitmap.GetPixel(k, j);

            builder.Append("image" + dt + " = {");
            for (int R = 0; R < bitmap.Height; R++)
            {
                for (int C = 0; C < bitmap.Width; C++)
                {
                    if (pix[R, C] != Color.Empty && pix[R, C].A != 0)
                    {
                        Color temp = pix[R, C];
                        int r = 0;
                        int c = 0;
                        while (R + r < bitmap.Height)
                        {
                            if (pix[R + r, C] != temp)
                                break;
                            r++;
                        }
                        while (C + c < bitmap.Width)
                        {
                            if (pix[R, C + c] != temp)
                                break;
                            c++;
                        }
                        int int_color = temp.R + temp.G * 256 + temp.B * 65536;
                        if (r > c)
                        {
                            for (int m = 0; m < r; m++)
                                pix[R + m, C] = Color.Empty;
                            builder.Append(C + "," + R + "," + 1 + "," + r + "," + int_color + ",");
                        }
                        else
                        {
                            for (int m = 0; m < c; m++)
                                pix[R, C + m] = Color.Empty;
                            builder.Append(C + "," + R + "," + c + "," + 1 + "," + int_color + ",");
                        }
                        boxsize++;
                    }
                }
            }
            builder.Remove(builder.Length - 1, 1);
            builder.Append("}\r\n");

            Clipboard.SetDataObject(builder.ToString(), true);
            System.Windows.Forms.MessageBox.Show("以复制到剪贴板,花费box数量:" + boxsize);
        }

        private void openFileDialog_FileOK(object sender, CancelEventArgs e)
        {
            System.Windows.Forms.MessageBox.Show(openFileDialog.FileName);
            image = Image.FromFile(openFileDialog.FileName);
        }
        private void trackBar_Scale_ValueChanged(object sender, EventArgs e)
        {
            pixivSize = trackBar_Scale.Value / 10f;
            pictureBox_Preview.Refresh();
        }
        private void trackBar_Quality_ValueChanged(object sender, EventArgs e)
        {
            pictureBox_Preview.Refresh();
        }
    }
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.Run(new MyForm());
        }
    }
}
