using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using WebApi.Domain;
using WebApi.DTOs;
using WebApi.Interface;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UtilizadorController : ControllerBase
    {
        private readonly IUsuarioRepository _usuarioRepository;

        public UtilizadorController(IUsuarioRepository usuarioRepository)
        {
            _usuarioRepository = usuarioRepository;
        }


        [HttpPost]
        public async Task<IActionResult> SaveProduct(Utilizador utilizador)
        {
            return Ok( await _usuarioRepository.Salvar(utilizador));
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDTO login)
        {
            return Ok(await _usuarioRepository.Login(login.Nome, login.Senha));
        }
        


        [HttpGet("usersById")]
        public async Task<IActionResult> GetUtilizadoresPorId(Guid id)
        {
            return Ok(await _usuarioRepository.UtilizadoresPorId(id));
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetUtilizadorPorId(Guid id)
        {
            return Ok(await _usuarioRepository.UtilizadorPorId(id));
        }


        [HttpGet("all")]
        public async Task<IActionResult> GetUtilizadores()
        {
            return Ok(await _usuarioRepository.Listar());
        }

    }
}
