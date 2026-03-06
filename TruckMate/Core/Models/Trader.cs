namespace TruckMate.Core.Models
{
    public class Trader
    {
        public int Id { get; set; }

        public string BusinessName { get; set; } = string.Empty;

        public string Address { get; set; } = string.Empty;

        public int UserId { get; set; }

        public People User { get; set; } = null!;
    }
}