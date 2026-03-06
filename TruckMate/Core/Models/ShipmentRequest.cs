using TruckMate.Core.Enums;

namespace TruckMate.Core.Models
{
    public class ShipmentRequest
    {
        public int Id { get; set; }

        public int TraderId { get; set; }
        public Trader Trader { get; set; } = null!;

        public string OriginCity { get; set; } = string.Empty;
        public string DestinationCity { get; set; } = string.Empty;

        public double Weight { get; set; }
        public string TruckType { get; set; } = string.Empty;

        public ShipmentStatus Status { get; set; } = ShipmentStatus.Pending;

        public bool IsReturnTrip { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public ICollection<Offer> Offers { get; set; } = new List<Offer>();
    }
}
