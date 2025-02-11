using WebApi.Domain;
using WebApi.DTOs;

namespace WebApi.Interface
{
    public interface IOcorrenciaRepository
    {
        Task<bool> Salvar(OcorrenciaDTO ocorrencia); 
        Task<List<Ocorrencia>> Listar(Guid userId);
        Task<List<Ocorrencia>> ListarTodos();
        Task<Ocorrencia> OcorrenciaPorId(Guid id);
        Task<bool> PartilharOcorrencia(PartilharOcorrenciaDTO ocorrencia);
    }
}
