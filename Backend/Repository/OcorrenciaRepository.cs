using Microsoft.EntityFrameworkCore;
using System.Net.Mail;
using System.Net;
using WebApi.Context;
using WebApi.Domain;
using WebApi.DTOs;
using WebApi.Interface;
//using MimeKit;

using MailKit.Net.Smtp;
using MimeKit;
using System.Runtime;
using MailKit.Security;
using System.Reflection;
using System.Text;
using System.ComponentModel;
using System.Linq;

namespace WebApi.Repository
{
    public class OcorrenciaRepository : IOcorrenciaRepository
    {

        private readonly ApplicationDbContext _context;

        public OcorrenciaRepository(ApplicationDbContext context)
        {
            _context = context;
        }
        public async Task<List<Ocorrencia>> Listar(Guid userId)
        {

            List<Ocorrencia> ocorrenciasResult = new List<Ocorrencia>();

            var ocorrencias = await _context.Ocorrencia.Where(p => p.UtilizadorId == userId).ToListAsync();
            var partilhadas = await _context.PartilhaOcorrencia.Where(p => p.UtilizadorId == userId)
                                            .Include(p => p.Ocorrencia)
                                            .ToListAsync();



            foreach (var ocorrencia in ocorrencias)
            {
                var partilhada = partilhadas.Where(p => p.Id == ocorrencia.Id).ToList();

                ocorrenciasResult.Add(ocorrencia);
            }
                
                


            foreach (var partilhada in partilhadas)
            {
                var ocorre = ocorrenciasResult.Where(p => p.Id == partilhada.OcorrenciaId).FirstOrDefault();
               

                if (ocorre == null)
                {
                    ocorrenciasResult.Add(partilhada.Ocorrencia);
                }
            }
            return ocorrenciasResult;

        }

        public async Task<List<Ocorrencia>> ListarTodos()
        {
            List<Ocorrencia> ocorrenciasResult = new List<Ocorrencia>();

            var ocorrencias = await _context.Ocorrencia.ToListAsync();
            var partilhadas = await _context.PartilhaOcorrencia.Include(p => p.Ocorrencia).ToListAsync();


            foreach (var ocorrencia in ocorrencias)
                ocorrenciasResult.Add(ocorrencia);


            foreach (var partilhada in partilhadas)
                ocorrenciasResult.Add(partilhada.Ocorrencia);

            return ocorrenciasResult;
        }

        public async Task<Ocorrencia?> OcorrenciaPorId(Guid id)
        {
            var reponse = await _context.Ocorrencia.Where(p => p.Id == id).Include(p => p.Utilizador).FirstOrDefaultAsync();
            if (reponse == null)
                return new Ocorrencia { };
            return reponse;


        }

        public async Task<bool> PartilharOcorrencia(PartilharOcorrenciaDTO ocorrencia)
        {

            CryptoHelper cry = new CryptoHelper();

           // cry.DecryptData("E3k1ksbxINQY7b7g7LlJVQ==");

            var partilha = new PartilhaOcorrencia
            {
                OcorrenciaId = Guid.Parse(cry.DecryptData(ocorrencia.OcorrenciaId.ToString())),
                UtilizadorId = Guid.Parse(cry.DecryptData(ocorrencia.UtilizadorId.ToString())),
            };

            if (Guid.Parse(cry.DecryptData(ocorrencia.Id.ToString()))  == Guid.Empty)
            {
                partilha.Id = Guid.NewGuid();
                await _context.PartilhaOcorrencia.AddAsync(partilha);

            }
            else
            {
                partilha.Id = partilha.Id;
                _context.PartilhaOcorrencia.Update(partilha);
            }
            await _context.SaveChangesAsync();


            var oco = await _context.PartilhaOcorrencia.Where(p=>p.OcorrenciaId == partilha.OcorrenciaId).Include(p=>p.Ocorrencia).ToListAsync();
            var fist = oco.FirstOrDefault();
            var utl = await _context.Utilizador.Where(p=>p.Id == partilha.UtilizadorId).FirstOrDefaultAsync();

            SendAsync($"Eu utilizador {utl.Nome} notifico ao Estado sobre a ocorrencia {fist.Ocorrencia.Descricao} | {fist.Ocorrencia.Classificar} e foi partilhada {oco.Count()}", "Notificação da partilha de ocorrencia!");
            return true;
        }

        public async Task<bool> Salvar(OcorrenciaDTO ocorrenciaDTO)
        {

            
        
             const string uploadsBaseUrl = "Uploads";

             if (!Directory.Exists(uploadsBaseUrl))
                 Directory.CreateDirectory(uploadsBaseUrl);


             string photoRelativePath = string.Empty;
             if (ocorrenciaDTO.File != null)
             {
                 // Gera um nome único para o arquivo
                 var photoFileName = $"{Guid.NewGuid()}_{ocorrenciaDTO.File.FileName}";
                 var absolutePhotoPath = Path.Combine(uploadsBaseUrl, photoFileName);

                 // Salva o arquivo na localização absoluta
                 using (var stream = new FileStream(absolutePhotoPath, FileMode.Create))
                 {
                     await ocorrenciaDTO.File.CopyToAsync(stream);
                 }

                 // Define o caminho relativo para salvar no banco de dados
                 photoRelativePath = photoFileName.Replace("\\", "/");
             }



             var ocorrencia = new Ocorrencia
             {
                 Latitude = ocorrenciaDTO.Latitude,
                 Longitude = ocorrenciaDTO.Longitude,
                 Classificar = ocorrenciaDTO.Classificar,
                 DataHora = DateTime.Now,
                 Descricao = ocorrenciaDTO.Descricao,
                 UtilizadorId = ocorrenciaDTO.UtilizadorId,
                 FotoVideo = photoRelativePath
             };

             if (ocorrenciaDTO.Id == Guid.Empty)
             {
                 ocorrencia.Id = Guid.NewGuid();
                 await _context.Ocorrencia.AddAsync(ocorrencia);
             }
             else
             {
                 ocorrencia.Id = ocorrenciaDTO.Id;
                 _context.Ocorrencia.Update(ocorrencia);
             }
             await _context.SaveChangesAsync();

            SendAsync("Olá, foi registada uma nova ocorrencia na aplicação! :)", "Nova Ocorrencia Cadastrada!");

            return true;
        }


        public  bool SendAsync(string mensagem,string titulo)
        {
            StringBuilder Body = new StringBuilder();
            Body.Append(mensagem);


            String HostSmtp = "smtp.gmail.com"; 
            String LoginSmtp = "lucasmudile@gmail.com";
            String PasswordSmtp = "bvic ohgm rsnc raar";
            Int32 PortaSmtp = 587;

            System.Net.Mail.SmtpClient Smtp = new System.Net.Mail.SmtpClient(HostSmtp, PortaSmtp);
            Smtp.UseDefaultCredentials = false;
            Smtp.EnableSsl = true;

            Smtp.Credentials = new NetworkCredential(LoginSmtp, PasswordSmtp);
            

            MailMessage mail = new MailMessage();
            mail.IsBodyHtml = true;
            mail.SubjectEncoding = System.Text.Encoding.UTF8;

            mail.From = new MailAddress("lucasmudile@gmail.com");
            mail.To.Add(new MailAddress("lucasmudile2018@gmail.com"));

            mail.Subject = titulo;
            mail.Body = Body.ToString();

            var Status = String.Empty;
            try
            {
                Smtp.Send(mail);
                Status = "Ok";
                return true;
            }
            catch (Exception exc)
            {
                Status = exc.Message;
            }
            return false;
        }


        private async Task ConnectSMTP(MailKit.Net.Smtp.SmtpClient client)
        {

           // if (_settings.SmtpUseSSL)
               await client.ConnectAsync("isptec.co.ao", 587, SecureSocketOptions.Auto);

           // else if (_settings.SmtpUseStartTls)
              //  await client.ConnectAsync("isptec.co.ao", 465, SecureSocketOptions.StartTls);
           // else
                //await client.ConnectAsync("isptec.co.ao", 587, SecureSocketOptions.Auto);
        }


        public void EnviarEmail()
        {
            try
            {


                var mensagem = new MimeMessage();
                mensagem.From.Add(new MailboxAddress("Estado", "20200592@isptec.co.ao"));
                mensagem.To.Add(new MailboxAddress("Lucas", "lucasmudile@gmail.com"));
                mensagem.Subject = "Teste";
                mensagem.Body = new TextPart("plain") { Text = "Este é um teste com MailKit." };

                using (var smtpClient = new MailKit.Net.Smtp.SmtpClient())
                {
                    smtpClient.Connect("smtp.gmail.com", 587, MailKit.Security.SecureSocketOptions.StartTls);
                    smtpClient.Authenticate("20200592@isptec.co.ao", "SasukeAbc123!");
                    smtpClient.Send(mensagem);
                    smtpClient.Disconnect(true);
                }
                Console.WriteLine("E-mail enviado!");


                /* SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587);
                 smtpClient.EnableSsl = true;
                 smtpClient.UseDefaultCredentials = false;
                 smtpClient.Credentials = new System.Net.NetworkCredential("20200592@isptec.co.ao", "SasukeAbc123!");
                 smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;

                 MailMessage mail = new MailMessage();
                 mail.From = new MailAddress("20200592@isptec.co.ao", "Estado");
                 mail.To.Add(new MailAddress("lucasmudile@gmail.com"));
                 mail.Subject = "Teste";
                 mail.Body = "Este é um e-mail de teste.";

                 smtpClient.Send(mail);*/


                /*SmtpClient smtpClient = new SmtpClient("smtp.gmail.com", 587);

                smtpClient.Credentials = new System.Net.NetworkCredential("20200592@isptec.co.ao", "123");
                // smtpClient.UseDefaultCredentials = true; // uncomment if you don't want to use the network credentials
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;

                smtpClient.UseDefaultCredentials = false;
                smtpClient.EnableSsl = true;
                MailMessage mail = new MailMessage();

                //Setting From , To and CC
                mail.From = new MailAddress("20200592@isptec.co.ao", "Estado");
                mail.To.Add(new MailAddress("lucasmudile@gmail.com"));
               // mail.CC.Add(new MailAddress("MyEmailID@gmail.com"));

                smtpClient.Send(mail);*/
                /*
                // Configuração do e-mail
                string smtpServer = "smtp.gmail.com"; // Servidor SMTP do provedor
                int smtpPort = 587; // Porta do SMTP (normalmente 587 para TLS, 465 para SSL)
                string emailRemetente = "20200592@isptec.co.ao";
                string senha = "SasukeAbc123!";

                string emailDestinatario = "lucasmudile@gmail.com";
                string assunto = "Nova Ocorrencia";
                string corpo = "Foi registada uma nova ocorrência na aplicação.";

                // Criando objeto de mensagem
                MailMessage mensagem = new MailMessage();
                mensagem.From = new MailAddress(emailRemetente);
                mensagem.To.Add(emailDestinatario);
                mensagem.Subject = assunto;
                mensagem.Body = corpo;
                mensagem.IsBodyHtml = false; // Defina como true se quiser enviar HTML

                // Configuração do SMTP
                SmtpClient clienteSmtp = new SmtpClient(smtpServer, smtpPort);
                clienteSmtp.UseDefaultCredentials = true;
                clienteSmtp.Credentials = new NetworkCredential(emailRemetente, senha);
                clienteSmtp.EnableSsl = true; // Definir como true se o provedor exigir SSL/TLS

                // Enviar e-mail
                clienteSmtp.Send(mensagem);*/

                Console.WriteLine("E-mail enviado com sucesso!");
            }
            catch (Exception ex)
            {
                Console.WriteLine("Erro ao enviar e-mail: " + ex.Message);
            }
        }
    }
}
