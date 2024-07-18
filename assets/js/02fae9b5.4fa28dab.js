"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[331],{3905:(e,n,t)=>{t.d(n,{Zo:()=>p,kt:()=>m});var r=t(67294);function a(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function o(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function l(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?o(Object(t),!0).forEach((function(n){a(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):o(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function c(e,n){if(null==e)return{};var t,r,a=function(e,n){if(null==e)return{};var t,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)t=o[r],n.indexOf(t)>=0||(a[t]=e[t]);return a}(e,n);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)t=o[r],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(a[t]=e[t])}return a}var u=r.createContext({}),i=function(e){var n=r.useContext(u),t=n;return e&&(t="function"==typeof e?e(n):l(l({},n),e)),t},p=function(e){var n=i(e.components);return r.createElement(u.Provider,{value:n},e.children)},s="mdxType",d={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},f=r.forwardRef((function(e,n){var t=e.components,a=e.mdxType,o=e.originalType,u=e.parentName,p=c(e,["components","mdxType","originalType","parentName"]),s=i(t),f=a,m=s["".concat(u,".").concat(f)]||s[f]||d[f]||o;return t?r.createElement(m,l(l({ref:n},p),{},{components:t})):r.createElement(m,l({ref:n},p))}));function m(e,n){var t=arguments,a=n&&n.mdxType;if("string"==typeof e||a){var o=t.length,l=new Array(o);l[0]=f;var c={};for(var u in n)hasOwnProperty.call(n,u)&&(c[u]=n[u]);c.originalType=e,c[s]="string"==typeof e?e:a,l[1]=c;for(var i=2;i<o;i++)l[i]=t[i];return r.createElement.apply(null,l)}return r.createElement.apply(null,t)}f.displayName="MDXCreateElement"},76647:(e,n,t)=>{t.r(n),t.d(n,{contentTitle:()=>l,default:()=>s,frontMatter:()=>o,metadata:()=>c,toc:()=>u});var r=t(87462),a=(t(67294),t(3905));const o={},l="Deque",c={type:"mdx",permalink:"/deque-luau/",source:"@site/pages/index.md",title:"Deque",description:"Deques are a generalization of stacks and queues.",frontMatter:{}},u=[{value:"Documentation",id:"documentation",level:2},{value:"Examples",id:"examples",level:2}],i={toc:u},p="wrapper";function s(e){let{components:n,...t}=e;return(0,a.kt)(p,(0,r.Z)({},i,t,{components:n,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"deque"},"Deque"),(0,a.kt)("p",null,"Deques are a generalization of stacks and queues."),(0,a.kt)("p",null,'The name is pronounced "deck" and is short for "double-ended queue".'),(0,a.kt)("p",null,"Get it here:"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},(0,a.kt)("a",{parentName:"li",href:"https://wally.run/package/egomoose/deque"},"Wally")),(0,a.kt)("li",{parentName:"ul"},(0,a.kt)("a",{parentName:"li",href:"https://github.com/EgoMoose/deque-luau/releases"},"Releases"))),(0,a.kt)("h2",{id:"documentation"},"Documentation"),(0,a.kt)("p",null,"Documentation is available at ",(0,a.kt)("a",{parentName:"p",href:"https://egomoose.github.io/deque-luau"},"https://egomoose.github.io/deque-luau"),"."),(0,a.kt)("h2",{id:"examples"},"Examples"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"local function getDescendantsBFS(root: Instance)\n    local descendants = {}\n    local queue = Deque.new(root:GetChildren())\n\n    while queue:getLength() > 0 do\n        local front = queue:popFront()\n\n        table.insert(descendants, front)\n\n        for _, child in front:GetChildren() do\n            queue:pushBack(child)\n        end\n    end\n    \n    return descendants\nend\n")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"local function getDescendantsDFS(root: Instance)\n    local descendants = {}\n    local stack = Deque.new(root:GetChildren())\n    stack:reverse()\n\n    while stack:getLength() > 0 do\n        local popped = stack:popBack()\n\n        table.insert(descendants, popped)\n\n        local children = popped:GetChildren()\n        for i = #children, 1, -1 do\n            stack:pushBack(children[i])\n        end\n    end\n\n    return descendants\nend\n")))}s.isMDXComponent=!0}}]);