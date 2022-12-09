// S-law model of linear pathway with feedback inhibition
// Author: jdv27@cornell.edu

#pragma::static
E1,E2,E3
#static::end

#pragma::dynamic
X1, X2, X3, X4, X5
#dynamic::end

#pragma::structure
// name::{reactants} --> {products}
// 1. name: reaction name (used in rate section)
// 2. {reactants}: list of dynamic species acting as a reactants
// 3. {products}: list of dynamic species acting as a reactants

// reactions in the pathway -
r1::{X1} --> X2
r2::{X2} --> X3
r3::X3 --> X4
r5::X3 --> X5

// reactions at the ends -
r0::{} --> X1
r4::X4 --> {}
#structure::end

#pragma::rate
// name::{factor_1,factor_2,....}
// 1: name = reaction name (must be in the #pragma::structure section)
// 2: list of factor symbols (can be both static and dynamic, order does not matter)
// 3: the order of the records does not matter here, we establish the order from the structure section
r0::{}
r1::{X1,X4,E1}
r2::{X2,E2}
r3::{X3,E3}
r4::{X4}
r5::{X3}
#rate::end