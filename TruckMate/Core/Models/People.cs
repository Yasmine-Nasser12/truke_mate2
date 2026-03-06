using TruckMate.Core.Enums;

namespace TruckMate.Core.Models
{
    public class People
    {
        public int Id { get; set; }

        public string FullName { get; set; } = string.Empty;

        public string Phone { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        public string NationalId { get; set; } = string.Empty;

        public string PasswordHash { get; set; } = string.Empty;

        public UserRole Role { get; set; }


    }
}