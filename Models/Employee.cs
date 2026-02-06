using System;
using System.Collections.Generic;

namespace rdi_rh_solution.Models;

public partial class Employee
{
    public Guid Id { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string Cpf { get; set; } = null!;

    public string Email { get; set; } = null!;

    public DateOnly BirthDate { get; set; }

    public DateOnly HireDate { get; set; }

    public bool IsActive { get; set; }

    public DateOnly? InactiveDate { get; set; }

    public Guid DepartmentId { get; set; }

    public Guid PositionId { get; set; }

    public Guid ProjectId { get; set; }

    public virtual Department Department { get; set; } = null!;

    public virtual Position Position { get; set; } = null!;

    public virtual Project Project { get; set; } = null!;

    public virtual User? User { get; set; }
}
