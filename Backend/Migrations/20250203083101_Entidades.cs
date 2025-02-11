using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WebApi.Migrations
{
    public partial class Entidades : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Utilizador",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Nome = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Senha = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Utilizador", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Ocorrencia",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    FotoVideo = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DataHora = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Latitude = table.Column<double>(type: "float", nullable: false),
                    Longitude = table.Column<double>(type: "float", nullable: false),
                    Descricao = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Classificar = table.Column<int>(type: "int", nullable: false),
                    UtilizadorId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ocorrencia", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Ocorrencia_Utilizador_UtilizadorId",
                        column: x => x.UtilizadorId,
                        principalTable: "Utilizador",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PartilhaOcorrencia",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    OcorrenciaId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UtilizadorId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PartilhaOcorrencia", x => x.Id);
                    table.ForeignKey(
                        name: "FK_PartilhaOcorrencia_Ocorrencia_OcorrenciaId",
                        column: x => x.OcorrenciaId,
                        principalTable: "Ocorrencia",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PartilhaOcorrencia_Utilizador_UtilizadorId",
                        column: x => x.UtilizadorId,
                        principalTable: "Utilizador",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.NoAction);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Ocorrencia_UtilizadorId",
                table: "Ocorrencia",
                column: "UtilizadorId");

            migrationBuilder.CreateIndex(
                name: "IX_PartilhaOcorrencia_OcorrenciaId",
                table: "PartilhaOcorrencia",
                column: "OcorrenciaId");

            migrationBuilder.CreateIndex(
                name: "IX_PartilhaOcorrencia_UtilizadorId",
                table: "PartilhaOcorrencia",
                column: "UtilizadorId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "PartilhaOcorrencia");

            migrationBuilder.DropTable(
                name: "Ocorrencia");

            migrationBuilder.DropTable(
                name: "Utilizador");
        }
    }
}
