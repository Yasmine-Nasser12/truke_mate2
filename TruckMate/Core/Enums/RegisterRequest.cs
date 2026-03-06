using TruckMate.Core.Enums;

public class RegisterRequest
{
    public UserRole Role { get; set; }

    public DriverSignUpDto Driver { get; set; }

    public TraderSignUpDto Trader { get; set; }
}