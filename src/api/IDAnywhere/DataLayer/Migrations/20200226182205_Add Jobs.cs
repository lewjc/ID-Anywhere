using System;
using Microsoft.EntityFrameworkCore.Migrations;

namespace DataLayer.Migrations
{
    public partial class AddJobs : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Job",
                columns: table => new
                {
                    ID = table.Column<int>(nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UserId = table.Column<string>(nullable: true),
                    ClaimedFirstName = table.Column<string>(nullable: true),
                    ClaimedLastName = table.Column<string>(nullable: true),
                    FirstNamePassport = table.Column<string>(nullable: true),
                    FirstNameLicense = table.Column<string>(nullable: true),
                    LastNameLicense = table.Column<string>(nullable: true),
                    LastNamePassport = table.Column<string>(nullable: true),
                    PassportNumber = table.Column<string>(nullable: true),
                    LicenseNumber = table.Column<string>(nullable: true),
                    PassportDateOfBirth = table.Column<DateTime>(nullable: false),
                    LicenseDateOfBirth = table.Column<DateTime>(nullable: false),
                    LicenseExpiry = table.Column<DateTime>(nullable: false),
                    PassportExpiry = table.Column<DateTime>(nullable: false),
                    MRZ = table.Column<string>(nullable: true),
                    Created = table.Column<DateTime>(nullable: false),
                    Valid = table.Column<bool>(nullable: false),
                    AppId = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Job", x => x.ID);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Job");
        }
    }
}
