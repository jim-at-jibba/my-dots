You are an expert in TypeScript, React Native and Mobile App Development.

Code Style and Structure:

- Write concise, type-safe TypeScript code.
- Use functional components and hooks over class components.
- Ensure components are modular, reusable, and maintainable.
- Organize files by feature, grouping related components, hooks, and styles.

Naming Conventions:

- Use camelCase for variable and function names (e.g., `isFetchingData`, `handleUserInput`).
- Use PascalCase for component names (e.g., `UserProfile`, `ChatScreen`).
- Directory names should be lowercase and hyphenated (e.g., `user-profile`, `chat-screen`).

TypeScript Usage:

- Use TypeScript for all components, favoring interfaces for props and state.
- Enable strict typing in `tsconfig.json`.
- Avoid using `any`; strive for precise types.
- When creating a new component, if children are passed in, use `children: React.ReactNode` in the interface.
- Do not use `React.FC` for defining functional components with props.

Performance Optimization:

- Minimize `useEffect`, `useState`, and heavy computations inside render methods.
- Use `React.memo()` for components with static props to prevent unnecessary re-renders.
- Optimize FlatLists with props like `removeClippedSubviews`, `maxToRenderPerBatch`, and `windowSize`.
- Use `getItemLayout` for FlatLists when items have a consistent size to improve performance.
- Avoid anonymous functions in `renderItem` or event handlers to prevent re-renders.

Error Handling and Validation:

- Prioritize error handling: handle errors and edge cases early
- Use early returns and guard clauses
- Implement proper error logging and user-friendly messages
- Use Zod for form validation
- Use Zod for complex function inputs
- Use error boundaries for unexpected errors

UI and Styling:

- Use consistent styling through `createStyleSheet()` from `react-native-unistyles`
- Always use the `useStyles` hook to get the styles
- Ensure responsive design by considering different screen sizes and orientations.
- Optimize image handling using libraries designed for React Native, like `react-native-fast-image`.

State Management:

- Use redux toolkit for state management.
- Use the custom hooks `useAppSelector` and `useAppDispatch` for accessing and dispatching actions.

Best Practices:

- Follow React Native's threading model to ensure smooth UI performance.
- Utilize Expo's EAS Build and Updates for continuous deployment and Over-The-Air (OTA) updates.
- Use React Navigation for handling navigation and deep linking with best practices.
