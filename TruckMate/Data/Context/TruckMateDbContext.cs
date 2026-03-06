using Microsoft.EntityFrameworkCore;
using TruckMate.Core.Models;

namespace TruckMate.Data.Context
{
    public class TruckMateDbContext : DbContext
    {
        public TruckMateDbContext(DbContextOptions<TruckMateDbContext> options)
            : base(options)
        {
        }

        public DbSet<People> Users { get; set; }
        public DbSet<Driver> Drivers { get; set; }
        public DbSet<Trader> Traders { get; set; }
        public DbSet<ShipmentRequest> ShipmentRequests { get; set; }
        public DbSet<Offer> Offers { get; set; }
        public DbSet<Trip> Trips { get; set; }
        public DbSet<Truck> trucks { get; set; }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

        }
    }
}