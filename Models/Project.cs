using System;
using System.Collections.Generic;

namespace rdi_rh_solution.Models;

public partial class Project
{
    public Guid Id { get; set; }

    public string Name { get; set; } = null!;

    public string Acronym { get; set; } = null!;

    public string? Description { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly EndDate { get; set; }

    public bool IsActive { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<Employee> Employees { get; set; } = new List<Employee>();

    public virtual ICollection<ProjectDepartment> ProjectDepartments { get; set; } = new List<ProjectDepartment>();
}
