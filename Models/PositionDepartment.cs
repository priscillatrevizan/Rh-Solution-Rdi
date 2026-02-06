using System;
using System.Collections.Generic;

namespace rdi_rh_solution.Models;

public partial class PositionDepartment
{
    public Guid Id { get; set; }

    public Guid? PositionId { get; set; }

    public Guid? DepartmentId { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual Department? Department { get; set; }

    public virtual Position? Position { get; set; }
}
