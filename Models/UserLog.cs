using System;
using System.Collections.Generic;

namespace rdi_rh_solution.Models;

public partial class UserLog
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string ActionDescription { get; set; } = null!;

    public string? ActionSnapshot { get; set; }

    public DateTime ActionDate { get; set; }

    public string ActionType { get; set; } = null!;

    public virtual User User { get; set; } = null!;
}
