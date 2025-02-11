using WebApi.Domain;

namespace WebApi.Interface
{
    public interface IUsuarioRepository
    {
        Task<string> Salvar(Utilizador utilizador); 
        Task<List<Utilizador>> Listar();
        Task<Utilizador> UtilizadorPorId(Guid id);
        Task<List<Utilizador>> UtilizadoresPorId(Guid id);
        Task<string> Login(string utilizador, string senha);



    }
}
