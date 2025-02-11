using Microsoft.EntityFrameworkCore;
using WebApi.Domain;

namespace WebApi.Context
{
    public class ApplicationDbContext:DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options):base(options)
        {
                
        }

        public DbSet<Utilizador> Utilizador { get; set; }
        public DbSet<PartilhaOcorrencia> PartilhaOcorrencia { get; set; }
        public DbSet<Ocorrencia> Ocorrencia { get; set; }
    }
}
