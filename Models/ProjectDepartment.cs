using System;
using System.Collections.Generic;

namespace rdi_rh_solution.Models;

public partial class ProjectDepartment
{
    public Guid ProjectId { get; set; }

    public Guid DepartmentId { get; set; }

    public DateOnly StartDate { get; set; }

    public DateOnly? FinishDate { get; set; }

    public virtual Department Department { get; set; } = null!;

    public virtual Project Project { get; set; } = null!;
}
