import type { ReactNode } from 'react';
export const Field=({label,children,required=true}:{label:string,children:ReactNode,required?:boolean})=><label className="field"><span>{label}{required&&<em>*</em>}</span>{children}</label>;
