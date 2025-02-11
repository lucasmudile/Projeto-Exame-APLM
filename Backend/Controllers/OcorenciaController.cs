using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApi.Domain;
using WebApi.DTOs;
using WebApi.Interface;
using WebApi.Repository;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OcorenciaController : ControllerBase
    {
        private readonly IOcorrenciaRepository _ocorrenciaRepository;

        public OcorenciaController(IOcorrenciaRepository ocorrenciaRepository)
        {
            _ocorrenciaRepository = ocorrenciaRepository;
        }

        [HttpPost]
        public async Task<IActionResult> SaveOcorrencia([FromForm] OcorrenciaDTO ocorrenciaDTO)
        {
            return Ok(await _ocorrenciaRepository.Salvar(ocorrenciaDTO));
        }

        [HttpPost("partilha")]
        public async Task<IActionResult> PartilharOcorrencia(PartilharOcorrenciaDTO partilharOcorrenciaDTO)
        {
            return Ok(await _ocorrenciaRepository.PartilharOcorrencia(partilharOcorrenciaDTO));
        }

        [HttpGet("list/{userId}")]
        public async Task<IActionResult> ListarOcorrencia(Guid userId)
        {
            return Ok(await _ocorrenciaRepository.Listar(userId));
        }
        // ListarTodos()
        [HttpGet("list")]
        public async Task<IActionResult> ListarTodosOcorrencia()
        {
            return Ok(await _ocorrenciaRepository.ListarTodos());
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> OcorrenciaPorId(Guid id)
        {
            return Ok(await _ocorrenciaRepository.OcorrenciaPorId(id));
        }
    }
}
