using System;
using System.Collections.Generic;

namespace rdi_rh_solution.Models;

public partial class User
{
    public Guid Id { get; set; }

    public string Email { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public string Role { get; set; } = null!;

    public bool IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateOnly? InactiveDate { get; set; }

    public Guid EmployeeId { get; set; }

    public virtual Employee Employee { get; set; } = null!;

    public virtual ICollection<UserLog> UserLogs { get; set; } = new List<UserLog>();
}
