namespace TruckMate.Core.Models
{
    public class Driver
    {
        public int Id { get; set; }

        public string LicenseNumber { get; set; } = string.Empty;

        public string LicenseType { get; set; } = string.Empty;

        public string PlateNumber { get; set; } = string.Empty;

        public string TruckType { get; set; } = string.Empty;

        public double Capacity { get; set; }

        public int UserId { get; set; }

        public People User { get; set; } = null!;
    }
}