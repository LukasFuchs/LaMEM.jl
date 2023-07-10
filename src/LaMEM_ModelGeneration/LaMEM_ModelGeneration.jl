# These are routines that allow us to fully create a LaMEM model in julia & run it
# In the background, it will create a lamem *.dat model setup and run that

module LaMEM_Model

using GeophysicalModelGenerator
using GeophysicalModelGenerator.GeoParams
using DocStringExtensions
import Base: show

# Few utils that are being used
filter_fields(fields, filter_out) = (setdiff(fields, filter_out)...,)
gettext_color(d,Reference, field) = getfield(d,field) != getfield(Reference,field) ? :blue : :default

function write_vec(data)
    if !isa(data,String)
        str = ""; for d in data; str = str*" $d" end
    else
        str = data
    end

    return str
end

"""
    help_info::String = get_doc(structure, field::Symbol) 
This returns a string with the documentation for a parameter `field` that is within the `structure`. 
Note that this structure must be a help structure of the current one.
"""
function get_doc(structure, field::Symbol) 
    alldocs       =   Docs.meta(LaMEM_Model);
    var           =   eval(Meta.parse("Docs.@var($structure)"))
    fields_local  =   alldocs[var].docs[Union{}].data[:fields]

    return fields_local[field]
end

include("Scaling.jl")   # Scaling
export Scaling 

include("Grid.jl")      # LaMEM grid 
export Grid

include("Time.jl")      # Timestepping
export Time

include("FreeSurface.jl")      # Free surface
export FreeSurface

include("BoundaryConditions.jl")      # Boundary Conditions
export BoundaryConditions

include("SolutionParams.jl")      # Solution parameters 
export SolutionParams

include("Model.jl")     # main LaMEM_Model
export Model

end