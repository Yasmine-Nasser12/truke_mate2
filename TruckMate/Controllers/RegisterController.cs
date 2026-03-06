using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;
using System.Text;
using TruckMate.Core.Enums;
using TruckMate.Core.Models;
using TruckMate.Data.Context;

namespace TruckMate.API.Controllers
{
    [ApiController]
    [Route("register")]
    public class RegisterController : ControllerBase
    {
        private readonly TruckMateDbContext _context;

        public RegisterController(TruckMateDbContext context)
        {
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> Register(RegisterRequest request)
        {
            if (request.Role == UserRole.Driver)
            {
                var driverDto = request.Driver;

                if (driverDto == null)
                    return BadRequest("Driver data is required.");

                var user = new People
                {
                    FullName = driverDto.FullName,
                    Phone = driverDto.Phone,
                    Email = driverDto.Email,
                    NationalId = driverDto.NationalId,
                    PasswordHash = HashPassword(driverDto.Password),
                    Role = UserRole.Driver
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                var driver = new Driver
                {
                    UserId = user.Id,
                    LicenseNumber = driverDto.LicenseNumber,
                    LicenseType = driverDto.LicenseType,
                    PlateNumber = driverDto.PlateNumber,
                    TruckType = driverDto.TruckType,
                    Capacity = driverDto.Capacity
                };

                _context.Drivers.Add(driver);
                await _context.SaveChangesAsync();

                return Ok(new
                {
                    message = "Driver registered successfully"
                });
            }

            else if (request.Role == UserRole.Trader)
            {
                var traderDto = request.Trader;

                if (traderDto == null)
                    return BadRequest("Trader data is required.");

                var user = new People
                {
                    FullName = traderDto.FullName,
                    Phone = traderDto.Phone,
                    Email = traderDto.Email,
                    NationalId = traderDto.NationalId,
                    PasswordHash = HashPassword(traderDto.Password),
                    Role = UserRole.Trader
                };

                _context.Users.Add(user);
                await _context.SaveChangesAsync();

                var trader = new Trader
                {
                    UserId = user.Id,
                    BusinessName = traderDto.BusinessName,
                    Address = traderDto.Address
                };

                _context.Traders.Add(trader);
                await _context.SaveChangesAsync();

                return Ok(new
                {
                    message = "Trader registered successfully"
                });
            }

            return BadRequest("Invalid role.");
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                var bytes = Encoding.UTF8.GetBytes(password);
                var hash = sha256.ComputeHash(bytes);
                return Convert.ToBase64String(hash);
            }
        }
    }
}
