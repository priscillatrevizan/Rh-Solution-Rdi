using System;
using System.Collections.Generic;

namespace rdi_rh_solution.Models;

public partial class Department
{
    public Guid Id { get; set; }

    public string Name { get; set; } = null!;

    public string Acronym { get; set; } = null!;

    public string? Description { get; set; }

    public bool IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateOnly? InactiveDate { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual ICollection<PositionDepartment> PositionDepartments { get; set; } = new List<PositionDepartment>();

    public virtual ICollection<ProjectDepartment> ProjectDepartments { get; set; } = new List<ProjectDepartment>();
}
