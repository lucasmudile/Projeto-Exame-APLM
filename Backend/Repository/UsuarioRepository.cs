using Microsoft.EntityFrameworkCore;
using WebApi.Context;
using WebApi.Domain;
using WebApi.Interface;

namespace WebApi.Repository
{
    public class UsuarioRepository : IUsuarioRepository
    {
        private readonly ApplicationDbContext _context;

        public UsuarioRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<List<Utilizador>> Listar()
        {
            return await _context.Utilizador.ToListAsync();
        }

        public async Task<string> Login(string utilizador, string senha)
        {
            var result = await _context.Utilizador.Where(p=>p.Nome == utilizador && p.Senha == senha).FirstOrDefaultAsync();

            if(result != null)
            {
                return result.Id.ToString();
            }
            return Guid.Empty.ToString();
        }

        public async Task<string> Salvar(Utilizador utilizador)
        {
            try
            {
                var validar = await _context.Utilizador.Where(p => p.Nome.ToLower() == utilizador.Nome.ToLower()).FirstOrDefaultAsync();

                if (validar != null)
                    return "Já existe um usuário com esse nome!";
                
                
                
                if (utilizador.Id == Guid.Empty) 
                {
                    utilizador.Id = Guid.NewGuid();
                   await _context.Utilizador.AddAsync(utilizador);
                }
                else
                {
                    _context.Utilizador.Update(utilizador);
                }
               await _context.SaveChangesAsync();
                return "true";
            }
            catch (Exception ex) 
            {
                return ex.Message;
            }
           
        }

        public async Task<Utilizador> UtilizadorPorId(Guid id)
        {
            return await _context.Utilizador.Where(p => p.Id == id).FirstOrDefaultAsync();

        }

        public async Task<List<Utilizador>> UtilizadoresPorId(Guid id)
        {
          var response =  await _context.Utilizador.Where(p => p.Id != id).ToListAsync();
            return response;
        }
    }
}
